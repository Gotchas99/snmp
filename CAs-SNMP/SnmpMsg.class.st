Class {
	#name : 'SnmpMsg',
	#superclass : 'Object',
	#instVars : [
		'pdu'
	],
	#category : 'CAs-SNMP-Protocol',
	#package : 'CAs-SNMP',
	#tag : 'Protocol'
}

{ #category : 'instance creation' }
SnmpMsg class >> readFrom:rcvBuf [
^self new readFrom:rcvBuf
]

{ #category : 'adding' }
SnmpMsg >> addVar: anOID value: aVal [
self assert:[pdu isNotNil].
	self pdu addVar: anOID value: aVal
]

{ #category : 'converting' }
SnmpMsg >> asAsn1Value [

	| cont |
	cont := {
		        self version.
		        self community.
		         pdu }.
	^ cont asAsn1Value
]

{ #category : 'codec' }
SnmpMsg >> asByteArray [

	| enc |
	self assert: [ pdu isNotNil ].
	enc := self asAsn1Value encodedValue.
	^ ByteArray streamContents: [ :s | (BERTLVStream on: s) nextPut: enc ]
]

{ #category : 'accessing' }
SnmpMsg >> community [ ^'public'
]

{ #category : 'codec' }
SnmpMsg >> decode: aByteArray [
"används ??"
	self halt.
]

{ #category : 'accessing' }
SnmpMsg >> firstOid [ 
^pdu firstOid
]

{ #category : 'instance creation' }
SnmpMsg >> get [

	pdu := PDU newGet
]

{ #category : 'instance creation' }
SnmpMsg >> getNext [

	pdu := PDU newGetNext
]

{ #category : 'instance creation' }
SnmpMsg >> initialize [

	super initialize.
	
]

{ #category : 'testing' }
SnmpMsg >> isError [

	^ pdu isError
]

{ #category : 'accessing' }
SnmpMsg >> pdu [ ^pdu
]

{ #category : 'printing' }
SnmpMsg >> printOn: aStream [

	aStream << 'an SnmpMsg(' << pdu pduType <<')'
]

{ #category : 'instance creation' }
SnmpMsg >> readFrom: rcvBuf [

	| enc |
	enc := ASN1 readEncodedValuesFrom: rcvBuf readStream.
	self assert:  enc isAsn1EncodedValue .
	self assert:  enc isConstructed .
	self assert:  (enc tag isLabelled: 'UNIVERSAL:16' ).
	self assert: (
		enc elements second contents asString = self community ).
	pdu := PDU readFrom: enc elements third.
	pdu isError ifTrue: [ Error signal: 'PDU error' ].
	^ self
]

{ #category : 'accessing' }
SnmpMsg >> reqId: anInt [
pdu reqId: anInt
]

{ #category : 'instance creation' }
SnmpMsg >> response [

	pdu := PDU newResponse
]

{ #category : 'adding' }
SnmpMsg >> variables [

	self assert: [ pdu isNotNil ].
^	self pdu varbinds
]

{ #category : 'accessing' }
SnmpMsg >> version [
	"0 means SNMP v1?
	1 means v2c"

	^ 1
]
