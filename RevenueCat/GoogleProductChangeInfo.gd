class_name GoogleProductChangeInfo
extends Reference

var OldProductIdentifier: String
var _ProrationMode: ProrationMode

func _init(OldProductIdentifier: String, _ProrationMode: ProrationMode):
	self.OldProductIdentifier = OldProductIdentifier
	self.ProrationMode = ProrationMode
