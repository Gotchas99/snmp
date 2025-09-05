Extension { #name : 'ASN1' }

{ #category : '*CAs-SNMP' }
ASN1 class >> decodeValue: anEncodedValue [
^ASN1EncodedType decodeValue: anEncodedValue
]
