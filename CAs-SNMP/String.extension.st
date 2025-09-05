Extension { #name : 'String' }

{ #category : '*CAs-SNMP' }
String >> asAsn1Oid [
"ASN1ObjectIdentifier contents: self"
	^ ASN1ObjectIdentifierType new newValue:self
]

{ #category : '*CAs-SNMP' }
String >> asn1TypeClass [

	^ "ASN1UTF8StringType" ASN1OctetStringType
]
