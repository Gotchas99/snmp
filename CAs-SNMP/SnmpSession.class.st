Class {
	#name : 'SnmpSession',
	#superclass : 'Object',
	#instVars : [
		'agent',
		'nextReqId',
		'watches',
		'hostNameOrIP'
	],
	#category : 'CAs-SNMP',
	#package : 'CAs-SNMP'
}

{ #category : 'adding' }
SnmpSession >> addWatch: anOid [

	watches add: anOid 
]

{ #category : 'accessing' }
SnmpSession >> agent [ ^

	agent 
]

{ #category : 'accessing' }
SnmpSession >> agent: aHostNameOrIP [
hostNameOrIP:=aHostNameOrIP.
	agent := NetNameResolver addressFromString: aHostNameOrIP
]

{ #category : 'initialization' }
SnmpSession >> close [

"	socket closeAndDestroy"
]

{ #category : 'instructions' }
SnmpSession >> get: listOfOids [

	| oids msg resp |
	oids := listOfOids isString
		        ifFalse: [ listOfOids ]
		        ifTrue: [ { listOfOids } ].
	msg := SnmpMsg new.
	oids do: [ :anOID | msg addVar: anOID value: nil ].
	resp := self send: msg.
	^ resp pdu varbinds 
]

{ #category : 'instructions' }
SnmpSession >> getSingle: anOid [

	| resp oid |
		oid := anOid.
	oid first = $. ifTrue: [ oid := oid allButFirst ].
	resp := self get: oid .
	^ resp at: oid 
]

{ #category : 'accessing' }
SnmpSession >> hostNameOrIP [ ^hostNameOrIP
]

{ #category : 'initialization' }
SnmpSession >> initialize [
	"För att få requst-id som inte kolliderar även om man har två sessioner mot samma agent. 
	skala till fem siffor"

	nextReqId := (10000 + (22000 * SharedRandom globalGenerator next))
		             asInteger. 
	watches := OrderedCollection new
]

{ #category : 'initialization' }
SnmpSession >> nextReqId [
nextReqId:=nextReqId+1.^nextReqId
]

{ #category : 'adding' }
SnmpSession >> removeWatch:anOid [
watches remove:anOid ifAbsent: []
]

{ #category : 'instructions' }
SnmpSession >> send: aMsg [

	| rcvBuf req socket rcvMsg |
	aMsg reqId: self nextReqId .
	req := aMsg asByteArray.
	socket := Socket newUDP.
	socket sendUDPData: req toHost: agent port: 161.
	rcvBuf := self waitForDataFor: 2 onSocket: socket.
	socket closeAndDestroy.
	rcvMsg := SnmpMsg readFrom: rcvBuf.
	^ rcvMsg
]

{ #category : 'waiting' }
SnmpSession >> waitForDataFor: timeout onSocket: aSocket [
	"Wait for the given nr of seconds for data to arrive.
	If it does not, execute <timedOutBlock>. "

	| startTime msecsDelta msecsElapsed res rcvBuf timedOutBlock |
	rcvBuf := ByteArray new: 1000.
	startTime := Time millisecondClockValue.
	msecsDelta := (timeout * 1000) truncated.
	[
		res := aSocket receiveUDPDataInto: rcvBuf.
		res first > 0 ] whileFalse: [
			(msecsElapsed := Time millisecondsSince: startTime) < msecsDelta
				ifFalse: [
						self error: 'timed out'.
						^ timedOutBlock value ].
			(Delay forMilliseconds: 10) wait ].
	^ rcvBuf first: res first
]

{ #category : 'adding' }
SnmpSession >> watches [ ^watches 

	
]
