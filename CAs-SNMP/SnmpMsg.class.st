Class {
	#name : 'SnmpMsg',
	#superclass : 'Object',
	#instVars : [
		'pdu'
	],
	#category : 'CAs-SNMP',
	#package : 'CAs-SNMP'
}

{ #category : 'instance creation' }
SnmpMsg class >> readFrom:rcvBuf [
^self new readFrom:rcvBuf
]

{ #category : 'adding' }
SnmpMsg >> addVar: anOID value: aVal [
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
	enc := self asAsn1Value encodedValue.
	^ByteArray streamContents: [ :s | (BERTLVStream on: s) nextPut: enc ]
]

{ #category : 'versions' }
SnmpMsg >> community [ ^'public'
]

{ #category : 'codec' }
SnmpMsg >> decode: aByteArray [
]

{ #category : 'versions' }
SnmpMsg >> initialize [
super initialize .
	pdu := PDU newGet
]

{ #category : 'testing' }
SnmpMsg >> isError [

	^ pdu isError
]

{ #category : 'versions' }
SnmpMsg >> pdu [ ^pdu
]

{ #category : 'instance creation' }
SnmpMsg >> readFrom: rcvBuf [

	| enc |
	enc := ASN1 readEncodedValuesFrom: rcvBuf readStream.
	self assert: enc isAsn1EncodedValue.
	self assert: enc isConstructed.
	self assert: (enc tag isLabelled: 'UNIVERSAL:16').
	self assert: enc elements second contents asString = self community.
	pdu := PDU readFrom: enc elements third.
	pdu isError ifTrue: [ Error signal: 'PDU error' ].
	^ self
]

{ #category : 'accessing' }
SnmpMsg >> reqId: anInt [
pdu reqId: anInt
]

{ #category : 'versions' }
SnmpMsg >> version [
	"0 means SNMP v1?
	1 means v2c"

	^ 1
]
