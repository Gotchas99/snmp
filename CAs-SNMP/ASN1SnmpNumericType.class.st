Class {
	#name : 'ASN1SnmpNumericType',
	#superclass : 'ASN1SnmpPrimitiveType',
	#category : 'CAs-SNMP',
	#package : 'CAs-SNMP'
}

{ #category : 'codec' }
ASN1SnmpNumericType class >> decode: aByteArray [

	^ASN1IntegerType decode: aByteArray
]

{ #category : 'codec' }
ASN1SnmpNumericType class >> encode: aByteArray [

^	ASN1IntegerType encode: aByteArray
]
