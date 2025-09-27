Class {
	#name : 'SnmpManager',
	#superclass : 'Object',
	#instVars : [
		'sessions',
		'service'
	],
	#category : 'CAs-SNMP',
	#package : 'CAs-SNMP'
}

{ #category : 'initialization' }
SnmpManager >> closeAll [
service stop.
	sessions do: [ :each | each close ].
	sessions := OrderedCollection new
]

{ #category : 'initialization' }
SnmpManager >> initialize [

	super initialize.
	sessions := OrderedCollection new.
	self setupService
]

{ #category : 'as yet unclassified' }
SnmpManager >> newSession: aHostNameOrIP [

	| sess |
	sess:= SnmpSession new agent: aHostNameOrIP .sessions add: sess.^sess

]

{ #category : 'as yet unclassified' }
SnmpManager >> send: aMsg to: aHostNameOrIP [

	| agent rcvBuf socket req  |
	req := aMsg asByteArray.
	agent := NetNameResolver addressFromString: aHostNameOrIP.
	rcvBuf := ByteArray new: 10000.
	socket := Socket newUDP.
	socket sendUDPData: req toHost: agent port: 161.
	"[ res := socket receiveUDPDataInto: rcvBuf ] doWhileTrue: [
		res first = 0 ]."
	rcvBuf := self waitForDataFor: 2 onSocket: socket.
	socket closeAndDestroy.
	^ rcvBuf
]

{ #category : 'initialization' }
SnmpManager >> sessions [
^
	sessions 
]

{ #category : 'initialization' }
SnmpManager >> setupService [

	service := TKTParameterizableService new.
	service name: 'SNMP watcher service'.
	service stepDelay: (Duration seconds: 1).
	service onSetUpDo: [ self traceCr: 'Snmp watcher started' ].
	service onTearDownDo: [
		self traceCr: 'Snmp watcher finished' "mgr closeAll" ].
	service step: [ self watcher ].
	service start


	"TKTParameterizableService allInstances ."
]

{ #category : 'initialization' }
SnmpManager >> stopService [

	service stop.
"	service:= nil."


	"TKTParameterizableService allInstances ."
]

{ #category : 'waiting' }
SnmpManager >> waitForDataFor: timeout ifClosed: closedBlock ifTimedOut: timedOutBlock [
	"Wait for the given nr of seconds for data to arrive.
	If it does not, execute <timedOutBlock>. If the connection
	is closed before any data arrives, execute <closedBlock>."

	| startTime msecsDelta msecsElapsed res socket rcvBuf |
	startTime := Time millisecondClockValue.
	msecsDelta := (timeout * 1000) truncated.
	[ res := socket receiveUDPDataInto: rcvBuf. res first>0 ] whileFalse: [
			(msecsElapsed := Time millisecondsSince: startTime) < msecsDelta
				ifFalse: [ ^ timedOutBlock value ].
			"readSemaphore waitTimeoutMilliseconds: msecsDelta - msecsElapsed"
			(Delay forMilliseconds: 100) wait ]
]

{ #category : 'waiting' }
SnmpManager >> waitForDataFor: timeout onSocket: aSocket [
	"Wait for the given nr of seconds for data to arrive.
	If it does not, execute <timedOutBlock>. If the connection
	is closed before any data arrives, execute <closedBlock>."

	| startTime msecsDelta msecsElapsed res rcvBuf timedOutBlock |
	rcvBuf := ByteArray new: 10000.
	startTime := Time millisecondClockValue.
	msecsDelta := (timeout * 1000) truncated.
	[
		res := aSocket receiveUDPDataInto: rcvBuf.
		res first > 0 ] whileFalse: [
			(msecsElapsed := Time millisecondsSince: startTime) < msecsDelta
				ifFalse: [
						self error: 'timed out'.
						^ timedOutBlock value ].
			"readSemaphore waitTimeoutMilliseconds: msecsDelta - msecsElapsed"
			(Delay forMilliseconds: 10) wait ].
		^ rcvBuf first: res first
]

{ #category : 'as yet unclassified' }
SnmpManager >> watcher [

	| future activeWatches |
	self traceCr: '---*---'.
	activeWatches := sessions select: [ :each | each watches isNotEmpty ].
	activeWatches do: [ :sess |
			sess watches do: [ :oid |
					future := [ sess getSingle: oid ] future.
					future onSuccessDo: [ :newval | "diff := newval - oldval."
							self traceCr:
								sess hostNameOrIP , ', Bytes in: ' , newval asString
							"oldval := newval" ] ] ]
]
