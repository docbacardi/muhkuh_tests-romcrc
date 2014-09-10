module("${MODULE_NAME}", package.seeall)

require("parameters")

CFG_strTestName = "${TEST_NAME}"

CFG_aParameterDefinitions = {
	{
		name="area_start",
		default=nil,
		help="Start address of the area to build the CRC32 for.",
		mandatory=false,
		validate=parameters.test_uint32,
		constrains=nil
	},
	{
		name="area_end",
		default=nil,
		help="End address of the area to build the CRC32 for.",
		mandatory=false,
		validate=parameters.test_uint32,
		constrains=nil
	},
	{
		name="expected_crc",
		default=nil,
		help="The expected CRC for the area.",
		mandatory=false,
		validate=parameters.test_uint32,
		constrains=nil
	}
}


local atDefaultParameters = {
	[romloader.ROMLOADER_CHIPTYP_NETX500] = {
		area_start = 0x00200000,
		area_end   = 0x00208000,
		crc        = 0x9fab86b3
	},
	[romloader.ROMLOADER_CHIPTYP_NETX100] = {
		area_start = 0x00200000,
		area_end   = 0x00208000,
		crc        = 0x4964cead
	},
	[romloader.ROMLOADER_CHIPTYP_NETX56] = {
		area_start = 0x000f0000,
		area_end   = 0x00100000,
		crc        = 0x8e74d29c
	},
	[romloader.ROMLOADER_CHIPTYP_NETX56B] = {
		area_start = 0x000f0000,
		area_end   = 0x00100000,
		crc        = 0x53cb8910
	},
	[romloader.ROMLOADER_CHIPTYP_NETX50] = {
		area_start = 0x08200000,
		area_end   = 0x08210000,
		crc        = 0x649294fb
	},
	[romloader.ROMLOADER_CHIPTYP_NETX10] = {
		area_start = 0x08070000,
		area_end   = 0x08080000,
		crc        = 0x0cf6ada3
	}
}


function run(aParameters)
	----------------------------------------------------------------------
	--
	-- Parse the parameters and collect all options.
	--
	local ulAreaStart   = tonumber(aParameters["area_start"])
	local ulAreaEnd     = tonumber(aParameters["area_end"])
	local ulExpectedCrc = tonumber(aParameters["expected_crc"])
	
	----------------------------------------------------------------------
	--
	-- Open the connection to the netX.
	-- (or re-use an existing connection.)
	--
	local tPlugin = tester.getCommonPlugin()
	if tPlugin==nil then
		error("No plug-in selected, nothing to do!")
	end

	local tAsicTyp = tPlugin:GetChiptyp()
	-- Get the binary for the ASIC.
	if tAsicTyp==romloader.ROMLOADER_CHIPTYP_NETX50 then
		uiAsic = 50
	elseif tAsicTyp==romloader.ROMLOADER_CHIPTYP_NETX100 or tAsicTyp==romloader.ROMLOADER_CHIPTYP_NETX500 then
		uiAsic = 500
	elseif tAsicTyp==romloader.ROMLOADER_CHIPTYP_NETX10 then
		uiAsic = 10
	elseif tAsicTyp==romloader.ROMLOADER_CHIPTYP_NETX56 or tAsicTyp==romloader.ROMLOADER_CHIPTYP_NETX56B then
		uiAsic = 56
	else
		error("Unknown chiptyp!")
	end

	-- Set default values.
	if ulAreaStart==nil or ulAreaEnd==nil or ulExpectedCrc==nil then
		atDefaults = atDefaultParameters[tAsicTyp]
		if atDefaults==nil then
			error(string.format("No default values for chiptype %d!", tAsicTyp))
		end
		if ulAreaStart==nil then
			ulAreaStart = atDefaults.area_start
		end
		if ulAreaEnd==nil then
			ulAreaEnd = atDefaults.area_end
		end
		if ulExpectedCrc==nil then
			ulExpectedCrc = atDefaults.crc
		end
	end

	-- Get the binary.
	local strBinaryName = string.format("netx/crctest_netx%d.bin", uiAsic)
	
	-- Construct the parameter.
	local aulParameter = {
		ulAreaStart,
		ulAreaEnd,
		0
	}

	-- Download and run the binary.
	local aAttr = tester.mbin_open(strBinaryName)
	tester.mbin_debug(aAttr)
	tester.mbin_write(nil, tPlugin, aAttr)
	tester.mbin_set_parameter(tPlugin, aAttr, aulParameter)
	local ulResult = tester.mbin_execute(nil, tPlugin, aAttr)
	if ulResult~=0 then
		error(string.format("The CRC test returned an error code: 0x%08x", ulResult))
	end
	
	-- Get the CRC.
	local ulNetxCrc = tPlugin:read_data32(aAttr.ulParameterStartAddress+0x0c+8)
	print(string.format("Calculated CRC: 0x%08x", ulNetxCrc))
	print(string.format("Expected CRC: 0x%08x", ulExpectedCrc))
	if ulNetxCrc~=ulExpectedCrc then
		error("The calculated CRC does not match the expected CRC!");
	end
	
	print("")
	print(" #######  ##    ## ")
	print("##     ## ##   ##  ")
	print("##     ## ##  ##   ")
	print("##     ## #####    ")
	print("##     ## ##  ##   ")
	print("##     ## ##   ##  ")
	print(" #######  ##    ## ")
	print("")
end

