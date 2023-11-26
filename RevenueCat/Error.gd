class_name Error

extends Reference

var Message: String
var Code: int
var UnderlyingErrorMessage: String
var ReadableErrorCode: String

func _init(response):
	Message = response["message"]
	Code = int(response["code"])
	UnderlyingErrorMessage = response["underlyingErrorMessage"]
	ReadableErrorCode = response["readableErrorCode"]

#func _to_string():
#	return $"{nameof(Message)}: {Message}, " +\
#                   $"{nameof(Code)}: {Code}, " +\
#                   $"{nameof(UnderlyingErrorMessage)}: {UnderlyingErrorMessage}, " +\
#                   $"{nameof(ReadableErrorCode)}: {ReadableErrorCode}"
