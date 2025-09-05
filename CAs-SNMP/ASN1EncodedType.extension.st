Extension { #name : 'ASN1EncodedType' }

{ #category : '*CAs-SNMP' }
ASN1EncodedType class >> createUniversalTagNumberMap [

	
	^ Dictionary new
		        at: 'BOOLEAN' put: 1;
		        at: 'INTEGER' put: 2;
		        at: 'BIT STRING' put: 3;
		        at: 'OCTET STRING' put: 4;
		        at: 'NULL' put: 5;
		        at: 'OBJECT IDENTIFIER' put: 6;
		        at: 'OPEN TYPE' put: 8;
		        at: 'EXTERNAL TYPE' put: 8;
		        at: 'ENUMERATED' put: 10;
		        at: 'UTF8String' put: 12;
		        at: 'SEQUENCE' put: 16;
		        at: 'SET' put: 17;
		        at: 'NumericString' put: 18;
		        at: 'PrintableString' put: 19;
		        at: 'TeletexString' put: 20;
		        at: 'UTCTime' put: 23;
		        at: 'IA5String' put: 27;
		        yourself.

]

{ #category : '*CAs-SNMP' }
ASN1EncodedType class >> decodeValue: anEncodedValue [

	| type tag val |
	tag := anEncodedValue tag.
	"self assert: tag clazz = 'UNIVERSAL'."
	type := self allSubclasses detect: [ :cls |
		        cls tagNumber = tag number ].
	val := type decode: anEncodedValue contents.
	^ val
]

{ #category : '*CAs-SNMP' }
ASN1EncodedType class >> resetUniversalTag [

 universalTag :=nil
]

{ #category : '*CAs-SNMP' }
ASN1EncodedType class >> universalType [

	^ 'NOT APPLICABLE to Abstract type'
]

{ #category : '*CAs-SNMP' }
ASN1EncodedType class >> universalTypeForNumber: anInt [

	^ self universalTagNumbers keyAtValue: anInt 
]
