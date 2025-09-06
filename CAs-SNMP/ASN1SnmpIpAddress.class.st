Class {
	#name : 'ASN1SnmpIpAddress',
	#superclass : 'ASN1SnmpPrimitiveType',
	#category : 'CAs-SNMP',
	#package : 'CAs-SNMP'
}

{ #category : 'codec' }
ASN1SnmpIpAddress class >> decode: aByteArray [

	^ ASN1OctetStringType decode: aByteArray
]

{ #category : 'codec' }
ASN1SnmpIpAddress class >> encode: aByteArray [

	^ ASN1OctetStringType encode: aByteArray
]

{ #category : 'accessing' }
ASN1SnmpIpAddress class >> snmpType [

	^ 'IpAddress'
]
