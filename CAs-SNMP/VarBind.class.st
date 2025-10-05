Class {
	#name : 'VarBind',
	#superclass : 'Object',
	#instVars : [
		'oid',
		'value'
	],
	#category : 'CAs-SNMP-Protocol',
	#package : 'CAs-SNMP',
	#tag : 'Protocol'
}

{ #category : 'as yet unclassified' }
VarBind class >> oid:anOID value:val [
^self new oid:anOID ;value:val
]

{ #category : 'converting' }
VarBind >> asAsn1Value [

	^self contents asAsn1Value 
]

{ #category : 'initialization' }
VarBind >> contents [

	^{oid asAsn1Oid  .
	value  } 
]

{ #category : 'codec' }
VarBind >> decode: aByteArray [
]

{ #category : 'initialization' }
VarBind >> encodeOn: aTLVstream [

	^{oid asAsn1Oid  encodedValue.
	value asAsn1Value encodedValue } asAsn1Value encodedValue 
]

{ #category : 'initialization' }
VarBind >> initialize [ super initialize .
]

{ #category : 'accessing' }
VarBind >> oid: anOid [

	| snmpOid |
	snmpOid := '1.3.6.1.'.
	oid := anOid.
	oid first = $. ifTrue: [ oid := oid allButFirst ].
	(oid beginsWith: snmpOid) ifFalse: [ oid := snmpOid , oid ] 
]

{ #category : 'accessing' }
VarBind >> value:aVal [
value:=aVal 
]
