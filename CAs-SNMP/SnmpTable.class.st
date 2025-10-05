Class {
	#name : 'SnmpTable',
	#superclass : 'Object',
	#instVars : [
		'mib',
		'tableOid',
		'tdata'
	],
	#category : 'CAs-SNMP-Application',
	#package : 'CAs-SNMP',
	#tag : 'Application'
}

{ #category : 'accessing' }
SnmpTable >> columns [
]

{ #category : 'accessing' }
SnmpTable >> data:tableData [

tdata :=tableData 
]

{ #category : 'accessing' }
SnmpTable >> indeces [
| idx tmp |
"idx:= Set new."
tmp := tdata collect:[:assoc| ($. split: assoc key)last ].
idx:=tmp asSet sorted.
^idx
]

{ #category : 'accessing' }
SnmpTable >> oid:anOid [
tableOid :=anOid 
]
