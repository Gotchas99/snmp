Extension { #name : 'ASN1SequenceValue' }

{ #category : '*CAs-SNMP' }
ASN1SequenceValue >> contents: aCollection [
self elements: aCollection 
]

{ #category : '*CAs-SNMP' }
ASN1SequenceValue >> encodedValue [

	^ type encodedValue: self elements
]

{ #category : '*CAs-SNMP' }
ASN1SequenceValue >> encodedValue: anObject [

	^ ASN1EncodedConstructedValue new
		  contents: (self class encode: anObject);
		  tag: self universalTag
]
