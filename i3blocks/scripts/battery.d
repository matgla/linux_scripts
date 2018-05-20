#!/usr/bin/env dub
/+ dub.sdl:
	name "i3blocks_battery"
+/

import std.regex;
import std.stdio;
import std.string;
import std.conv;
import std.process;

immutable CHARGING_TEXT = "<span color='yellow'><span font='Icons'>\uf237</span></span>";
immutable CHARGER_CONNECTED_TEXT = "<span color='green'><span font='Font Awesome'>\uf1e6</span></span>";
immutable NO_BATTERY_TEXT = "<span color='red'><span font='Icons'>\uf229 \uf212</span></span>";
immutable BATTERY_LOW_TEXT = "<span color='red'><span font='Icons'>\uf212</span></span>";
immutable BATTERY_MEDIUM_TEXT = "<span color='green'><span font='Icons'>\uf215</span></span>";
immutable BATTERY_HIGH_TEXT = "<span color='green'><span font='Icons'>\uf214</span></span>";
immutable BATTERY_FULL_TEXT = "<span color='green'><span font='Icons'>\uf213</span></span>";
immutable CANT_READ_BATTERY_TEXT = "<span color='red'><span font='DejaVu Sans Mono'>! No ACPI</span></span>";

immutable int BATTERY_LOW_TRESHOLD = 15;
immutable int BATTERY_MEDIUM_TRESHOLD = 50;
immutable int BATTERY_HIGH_TRESHOLD = 85;
immutable int BATTERY_FULL_TRESHOLD = 100;

class BatteryInfo 
{

	public this() 
	{
		hasBattery_ = false;
		status_ = Status.Unknown;
		batteryValueText_ = "";
		batteryValue_ = 0; 
	}

	public void parse(string acpiString) 
	{
		auto splittedBattery = acpiString.split(",");

		hasBattery_ = hasBattery(splittedBattery[0]);
		if (hasBattery_)
		{
			auto batteryInfo = splittedBattery[0].split(":");
			if (batteryInfo.length < 2) 
			{
				status_ = Status.Unknown;
			} 
			else 
			{
				auto status = batteryInfo[1].strip();
				switch(status) 
				{
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
            batteryValueText_ = getPercent(acpiString);
			batteryValue_ = getBatteryValue(batteryValueText_);
		}
	}

	public string getBatteryText() 
	{
		return getBatteryStatusText() ~ getBatteryIcon() ~ " " ~ getPercentText();
	}

	private enum Status {
		Charging,
		Discharging,
		Full,
		Unknown
	};

	private string getPercentText() { 
		return batteryValueText_;
	}

	private string getBatteryIcon() {
		if (!hasBattery_) 
		{
			return NO_BATTERY_TEXT;
		}

		if (batteryValue_ <= BATTERY_LOW_TRESHOLD)
		{
			return BATTERY_LOW_TEXT;
		}
		else if (batteryValue_ > BATTERY_LOW_TRESHOLD && batteryValue_ <= BATTERY_MEDIUM_TRESHOLD)
		{
			return BATTERY_MEDIUM_TEXT;
		}
		else if (batteryValue_ > BATTERY_MEDIUM_TRESHOLD && batteryValue_ <= BATTERY_HIGH_TRESHOLD)
		{
			return BATTERY_HIGH_TEXT;
		}
		else if (batteryValue_ > BATTERY_HIGH_TRESHOLD)
		{
			return BATTERY_FULL_TEXT;
		}

		return NO_BATTERY_TEXT;
	}

	private string getBatteryStatusText() 
	{
		switch (status_) {
			case Status.Charging: 
				return CHARGING_TEXT;
			case Status.Full:
				return CHARGER_CONNECTED_TEXT;
			default:
				return "";
		}
		
	}

	private string getPercent(string acpiString) 
	{
		auto percentRegex = regex(r"(?:[0-9])?[0-9]?[0-9]%");
		auto matched = matchFirst(acpiString, percentRegex);
		string batteryText = "--%";
		if (matched.empty) {
			return batteryText;
		}
        batteryText = matched.hit();
		return batteryText;
	}

	private int getBatteryValue(string batteryValueText)
	{
		return to!int(batteryValueText.strip("%"));
	}

	private bool hasBattery(string text) 
	{
		auto batteryRegex = regex(r"battery", "gi");
		auto matched = match(text, batteryRegex);
		return !matched.empty();
	}

	private bool hasBattery_;
	private Status status_;
	private string batteryValueText_;
	private int batteryValue_;
};

void main() {
	try 
	{
		auto acpi = execute(["acpi"]);
		auto batteryInfo = new BatteryInfo();

		if (acpi.status == 0) {
			batteryInfo.parse(acpi.output);
			writeln(batteryInfo.getBatteryText());
			return;
		}  

		writeln(CANT_READ_BATTERY_TEXT);

	} 
	catch(ProcessException)
	{
		writeln(CANT_READ_BATTERY_TEXT);
	}
}

unittest /* no battery */ {
	const string acpiString = "you shall not pass";
	auto batteryInfo = new BatteryInfo();

	batteryInfo.parse(acpiString);
	assert(batteryInfo.getBatteryText() == NO_BATTERY_TEXT);
}

unittest /* charging low battery */ {
	immutable lowBatteryValue = to!string(BATTERY_LOW_TRESHOLD / 2) ~ "%";

	const string acpiString = "Battery 0: Charging, " ~ lowBatteryValue ~ ", 01:10:12 remaining";
	auto batteryInfo = new BatteryInfo();

	batteryInfo.parse(acpiString);
	assert(batteryInfo.getBatteryText() == CHARGING_TEXT ~ BATTERY_LOW_TEXT ~ lowBatteryValue);
}

unittest /* discharging low battery */ {
	immutable lowBatteryValue = to!string(BATTERY_LOW_TRESHOLD) ~ "%";

	const string acpiString = "Battery 0: Discharging, " ~ lowBatteryValue ~ ", 01:10:12 remaining";
	auto batteryInfo = new BatteryInfo();

	batteryInfo.parse(acpiString);
	assert(batteryInfo.getBatteryText() == BATTERY_LOW_TEXT ~ lowBatteryValue);
}

unittest /* charging medium battery */ {
	immutable mediumBatteryValue = to!string(BATTERY_MEDIUM_TRESHOLD) ~ "%";

	const string acpiString = "Battery 0: Charging, " ~ mediumBatteryValue ~ ", 01:10:12 remaining";
	auto batteryInfo = new BatteryInfo();

	batteryInfo.parse(acpiString);
	assert(batteryInfo.getBatteryText() == CHARGING_TEXT ~ BATTERY_MEDIUM_TEXT ~ mediumBatteryValue);
}

unittest /* discharging medium battery */ {
	immutable mediumBatteryValue = to!string(BATTERY_MEDIUM_TRESHOLD) ~ "%";

	const string acpiString = "Battery 0: Discharging, " ~ mediumBatteryValue ~ ", 01:10:12 remaining";
	auto batteryInfo = new BatteryInfo();

	batteryInfo.parse(acpiString);
	assert(batteryInfo.getBatteryText() == BATTERY_MEDIUM_TEXT ~ mediumBatteryValue);
}

unittest /* charging high battery */ {
	immutable highBatteryValue = to!string(BATTERY_HIGH_TRESHOLD) ~ "%";

	const string acpiString = "Battery 0: Charging, " ~ highBatteryValue ~ ", 01:10:12 remaining";
	auto batteryInfo = new BatteryInfo();

	batteryInfo.parse(acpiString);
	assert(batteryInfo.getBatteryText() == CHARGING_TEXT ~ BATTERY_HIGH_TEXT ~ highBatteryValue);
}

unittest /* discharging high battery */ {
	immutable highBatteryValue = to!string(BATTERY_HIGH_TRESHOLD) ~ "%";

	const string acpiString = "Battery 0: Discharging, " ~ highBatteryValue ~ ", 01:10:12 remaining";
	auto batteryInfo = new BatteryInfo();

	batteryInfo.parse(acpiString);
	assert(batteryInfo.getBatteryText() == BATTERY_HIGH_TEXT ~ highBatteryValue);
}

unittest /* charging full battery */ {
	immutable fullBatteryValue = to!string(BATTERY_HIGH_TRESHOLD + 1) ~ "%";

	const string acpiString = "Battery 0: Charging, " ~ fullBatteryValue ~ ", 01:10:12 remaining";
	auto batteryInfo = new BatteryInfo();

	batteryInfo.parse(acpiString);
	assert(batteryInfo.getBatteryText() == CHARGING_TEXT ~ BATTERY_FULL_TEXT ~ fullBatteryValue);
}

unittest /* discharging full battery */ {
	immutable fullBatteryValue = to!string(BATTERY_HIGH_TRESHOLD + 1) ~ "%";

	const string acpiString = "Battery 0: Discharging, " ~ fullBatteryValue ~ ", 01:10:12 remaining";
	auto batteryInfo = new BatteryInfo();

	batteryInfo.parse(acpiString);
	assert(batteryInfo.getBatteryText() == BATTERY_FULL_TEXT ~ fullBatteryValue);
}

unittest /* charger connected full battery */ {
	immutable fullBatteryValue = to!string(BATTERY_HIGH_TRESHOLD + 1) ~ "%";

	const string acpiString = "Battery 0: Full, " ~ fullBatteryValue ~ ", 01:10:12 remaining";
	auto batteryInfo = new BatteryInfo();

	batteryInfo.parse(acpiString);
	assert(batteryInfo.getBatteryText() == CHARGER_CONNECTED_TEXT ~ BATTERY_FULL_TEXT ~ fullBatteryValue);
}
