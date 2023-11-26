class_name LogLevel
extends Reference

enum LogLevel{
		VERBOSE,
		DEBUG,
		INFO,
		WARN,
		ERROR
}

func ParseLogLevelByName(name: String):
	for field in self.LogLevel.keys():
		if field == name:
			return self.LogLevel[field]
	return self.LogLevel.Info
