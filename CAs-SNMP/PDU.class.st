Class {
	#name : 'PDU',
	#superclass : 'Object',
	#instVars : [
		'varbinds',
		'reqId',
		'error',
		'errIndex',
		'pduType'
	],
	#classInstVars : [
		'pduCodes'
	],
	#category : 'CAs-SNMP',
	#package : 'CAs-SNMP'
}

{ #category : 'class initialization' }
PDU class >> initialize [

	pduCodes := Dictionary new.
	pduCodes at:#GET put:16rA0.
]

{ #category : 'instance creation' }
PDU class >> newGet [
^self new get
]

{ #category : 'accessing' }
PDU class >> pduCodeAt:aRecType [
"#GET, #GETNEXT"
pduCodes at:aRecType 
]

{ #category : 'instance creation' }
PDU class >> readFrom: enc [

	^ self new readFrom: enc
]

{ #category : 'converting' }
PDU >> addVar: anOID value: aVal [
| vb |
vb:= VarBind oid: anOID value: aVal .varbinds add:vb.
]

{ #category : 'converting' }
PDU >> asAsn1Value [

^ self asn1TypeClass new newValue: self 
]

{ #category : 'as yet unclassified' }
PDU >> asn1TypeClass [
^ASN1PDUType classForPDUtype: pduType 
]

{ #category : 'enumerating' }
PDU >> collect: aBlock [

	^ self elements collect: aBlock
]

{ #category : 'initialization' }
PDU >> decode: aByteArray [
]

{ #category : 'accessing' }
PDU >> elements [

	^ { reqId .
	error .
	errIndex.
	varbinds  }
]

{ #category : 'initialization' }
PDU >> encodeOn: aStream [

	
]

{ #category : 'actions api' }
PDU >> get [

	pduType := 'Get-PDU'
]

{ #category : 'initialization' }
PDU >> initialize [

	super initialize.
	self get.
	reqId := 0.
	error := 0.
	errIndex := 0.
	varbinds := OrderedCollection new
]

{ #category : 'testing' }
PDU >> isError [ ^error >0
]

{ #category : 'accessing' }
PDU >> pduType [ ^pduType
]

{ #category : 'instance creation' }
PDU >> readFrom: enc [
	"make sure it is a Response PDU"

	| varbindList |
	self assert: (enc tag isLabelled: 'CONTEXT:2').
	reqId := ASN1EncodedType decodeValue: enc elements first.
	error := ASN1EncodedType decodeValue: enc elements second.
	errIndex := ASN1EncodedType decodeValue: enc elements third.
varbindList := ASN1EncodedType decodeValue: enc elements fourth.
	varbinds:=Dictionary newFrom: (varbindList collect:[:each|Association key: each  first value:each second] ).
	^ self
]

{ #category : 'accessing' }
PDU >> reqId:anInt [ reqId:=anInt 
]

{ #category : 'converting' }
PDU >> varbinds [
^	varbinds 
]
