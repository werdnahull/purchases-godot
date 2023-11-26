class_name IntroEligibility
extends Reference

# The introductory price eligibility status
var Status: IntroEligibilityStatus

# Description of the status
var Description: String

func _init(response):
	Status = IntroEligibilityStatus.STATUS[response["status"].to_int()]
	Description = response["description"]
