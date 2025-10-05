Class {
	#name : 'SnmpSession',
	#superclass : 'Object',
	#instVars : [
		'nextReqId',
		'lastOid',
		'watches',
		'hostNameOrIP',
		'agent'
	],
	#category : 'CAs-SNMP-Application',
	#package : 'CAs-SNMP',
	#tag : 'Application'
}

{ #category : 'as yet unclassified' }
SnmpSession class >> sampleOIDs [

	'1.3.6.1.2.1.2.2.1.10.1' "if bytes in. sista .1 är port i switchen"
]

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

{ #category : 'instructions' }
SnmpSession >> checkError:resp [ .
resp isError ifTrue:[self error:'PDU error']
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
	msg := SnmpMsg new get.
	oids do: [ :anOID | msg addVar: anOID value: nil ].
	resp := self send: msg.
	self checkError: resp.
	lastOid := oids first.
	^ resp pdu varbinds
]

{ #category : 'instructions' }
SnmpSession >> getNext [

	| resp  msg |
	self assert: [ lastOid isNotNil ].
	msg := SnmpMsg new getNext.
	msg addVar: lastOid value: nil.
	resp := self send: msg.
	self checkError: resp.
	lastOid := resp firstOid.

	^ resp variables
]

{ #category : 'instructions' }
SnmpSession >> getSingle: anOid [

	| resp oid |
	oid := self normalizeOid: anOid .
	resp := self get: oid.
	"anyOne ger ett godtyckligt _värde_ ur ett Dictionary, 
	men om vi vet att det bara finns ett, så är det just det värdet"
	^ resp anyOne
]

{ #category : 'instructions' }
SnmpSession >> getTable: anOid [

	| tableOid resp  tbl |
	tableOid := self normalizeOid: anOid.
	resp := self getTableData: tableOid.
tbl:= SnmpTable new oid: tableOid ;data: resp.	
	^ tbl
]

{ #category : 'instructions' }
SnmpSession >> getTableData: anOid [

	| resp tableOid tData |
	tableOid := self normalizeOid: anOid.
	tData := OrderedCollection new.
	"resp := (self get: tableOid) associations first.
	tData add: resp."
	self get: tableOid.
	[
		resp := self getNext associations first.
		self is: resp key containedWithin: tableOid ] whileTrue: [
		tData add: resp ].
	^ tData
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

{ #category : 'testing' }
SnmpSession >> is: anOid containedWithin: aBaseOid [

	^anOid beginsWith:aBaseOid 
]

{ #category : 'initialization' }
SnmpSession >> nextReqId [
nextReqId:=nextReqId+1.^nextReqId
]

{ #category : 'instructions' }
SnmpSession >> normalizeOid: anOid [
| snmpOid oid |
snmpOid := '1.3.6.1.'.
	oid := anOid.
	oid first = $. ifTrue: [ oid := oid allButFirst ].
	(oid beginsWith: snmpOid) ifFalse: [ oid := snmpOid , oid ].
	^oid
]

{ #category : 'adding' }
SnmpSession >> removeWatch:anOid [
watches remove:anOid ifAbsent: []
]

{ #category : 'instructions' }
SnmpSession >> send: aMsg [

	| rcvBuf req socket rcvMsg |
	aMsg reqId: self nextReqId.
	req := aMsg asByteArray.
	socket := Socket newUDP.
	socket sendUDPData: req toHost: agent port: 161.
	rcvBuf := self waitForDataFor: 2 onSocket: socket.
	socket closeAndDestroy.
	rcvMsg := SnmpMsg new  readFrom: rcvBuf.
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
