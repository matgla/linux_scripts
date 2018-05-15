#!/usr/bin/env dub
/+ dub.sdl:
	name "hello"
+/

import std.regex;
import std.stdio;
import std.string;
import std.conv;
import std.process;

class BatteryInfo {
	
	enum Status {
		Charging,
		Discharging,
		Full,
		Unknown
	}

public: 
	this(string acpiString) {
		acpiString_ = acpiString;
		hasBattery_ = false;
		status_ = Status.Unknown;
	}

	string getRaw() {
		return acpiString_;
	}

	void acpiString(string acpiString) {
		acpiString_ = acpiString;
	}

	bool hasBattery_;
	Status status_;
	
	void parse() {
		auto splittedBattery = acpiString_.split(",");
		hasBattery_ = hasBattery(splittedBattery[0]);
		if (hasBattery_)
		{
			auto batteryInfo = splittedBattery[0].split(":");
			if (batteryInfo.length < 2) {
				status_ = Status.Unknown;
			} else {
				auto status = batteryInfo[1].strip();
				switch(status) {
					case "Discharging":
						status_ = Status.Discharging;
						break;
					case "Full":
						status_ = Status.Full;
						break;
					case "Unknown":
						status_ = Status.Unknown;
						break;
					default:
						status_ = Status.Charging;
						break;
				}
			}
		}
	}

	string getPercentText() {
		return "";
	}

	string getBatteryIcon() {
		return "";
	}

	string getBatteryStatusText() {
		switch (status_) {
			case Status.Charging: 
				return "<span color='yellow'><span font='Icons'>\uf237</span></span>";
			case Status.Full:
				return "<span color='green'><span font='Font Awesome'>\uf1e6</span></span>";
			default:
				return "";
		}
		
	}

	string getPercent() {
		auto percentRegex = regex(r"(?:[0-9])?[0-9]?[0-9]%");
		auto matched = matchFirst(acpiString_, percentRegex);
		if (matched.empty) {
			return "--%";
		}
		return matched.hit();
	}
	string getBatteryText() {
		if (!hasBattery_) {
			return emptyBatteryText();
		}
		return getBatteryStatusText() ~ " " ~ getBatteryIcon() ~ " " ~ getPercentText();
	}
private:

	bool hasBattery(string text) {
		auto batteryRegex = regex(r"battery", "gi");
		auto matched = match(text, batteryRegex);
		return !matched.empty();
	}

	string emptyBatteryText() {
		return "<span color='red'><span font='Icons'>\uf229 \uf212</span></span>";
	}

	string acpiString_;
};

void main() {
	auto acpi = execute(["acpi"]);
	auto batteryInfo = new BatteryInfo("");

	if (acpi.status != 0) {
		batteryInfo.acpiString(acpi.output);
	}  

	batteryInfo.parse();
	writeln(batteryInfo.getBatteryText());
}

unittest /* getPercentTests */ {
	auto batteryInfo = new BatteryInfo("some data 52% aa");
	assert(batteryInfo.getPercent() == "52%");
	batteryInfo.acpiString("1112 1223 981%");
	assert(batteryInfo.getPercent() == "981%");
	batteryInfo.acpiString("1112 0%");
	assert(batteryInfo.getPercent() == "0%");
	batteryInfo.acpiString("no percent here");
	assert(batteryInfo.getPercent() == "--%");
}

unittest /*hasBattery */ {
	auto batteryInfo = new BatteryInfo("some data 52% aa");
	assert(batteryInfo.hasBattery() == false);
	batteryInfo.acpiString("Battery 0: data 1");
	assert(batteryInfo.hasBattery() == true);
	batteryInfo.acpiString("Battery 0: data 1 Battery 2");
	assert(batteryInfo.hasBattery() == true);
}

unittest /* success scenario */ {
	const string acpiString = "Battery 0: Discharging, 61%, 01:10:12 remaining";
	auto batteryInfo = new BatteryInfo(acpiString);
	assert(batteryInfo.getRaw() == acpiString);
	assert(batteryInfo.getPercent() == "61%");
}