Class {
	#name : 'VarBind',
	#superclass : 'Object',
	#instVars : [
		'oid',
		'value'
	],
	#category : 'CAs-SNMP',
	#package : 'CAs-SNMP'
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
VarBind >> oid: anOID [

	oid := anOID.
	(oid first=$.)ifTrue: [ oid:=oid allButFirst ]
]

{ #category : 'accessing' }
VarBind >> value:aVal [
value:=aVal 
]
