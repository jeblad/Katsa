--- Tests for the spy module.

local testframework = require 'Module:TestFramework'

local Spy = require 'spy'
assert( Spy )

local function testExists()
	return type( Spy )
end

local function testRun( spy, ... )
	local keep1 = nil
	local keep2 = nil
	local func = function( tbl, ... ) keep1 = tbl ; keep2 = { ... } end
	spy:addCallback( func )
	return pcall( function( ... ) return spy( ... ) end, ... ), keep1, keep2
end

local function testConvenience( spy, ... )
	return pcall( function( ... ) return { spy( ... ) } end, ... )
end

local tests = {
	{ -- 1
		name = 'Verify the lib is loaded and exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{ -- 2
		name = 'Calling "new" without args',
		func = testRun,
		args = { Spy.new() },
		expect = { true, {}, {} }
	},
	{ -- 3
		name = 'Calling "new" with "foo" as arg',
		func = testRun,
		args = { Spy.new(), 'foo' },
		expect = { true, { 'foo' }, {} }
	},
	{ -- 4
		name = 'Calling "new" with "foo" as arg, and two callbacks adding "bar" and "baz"',
		func = testRun,
		args = { Spy.new()
			:addCallback( function(t) table.insert( t, 'bar' ) end, 1 )
			:addCallback( function(t) table.insert( t, 'baz' ) end, 2 ),
			'foo' },
		expect = { true, { 'foo', 'bar', 'baz' }, {} }
	},
	{ -- 5
		name = 'Calling "new" with "foo" as arg, and two callbacks adding "baz" and "bar"',
		func = testRun,
		args = { Spy.new()
			:addCallback( function(t) table.insert( t, 'bar' ) end, 2 )
			:addCallback( function(t) table.insert( t, 'baz' ) end, 1 ),
			'foo' },
		expect = { true, { 'foo', 'baz', 'bar' }, {} }
	},
	{ -- 6
		name = 'Calling "new" with "foo" as arg and "bar" as data',
		func = testRun,
		args = { Spy.new( 'bar' ), 'foo' },
		expect = { true, { 'foo' }, { 'bar' } }
	},
	{ -- 7
		name = 'Calling "newCarp" without args',
		func = testConvenience,
		args = { Spy.newCarp() },
		expect = { true, {} }
	},
	{ -- 8
		name = 'Calling "newCarp" convenience with "foo" as arg',
		func = testConvenience,
		args = { Spy.newCarp(), 'foo' },
		expect = { true, { 'foo' } }
	},
	{ -- 9
		name = 'Calling "newCluck" without args',
		func = testConvenience,
		args = { Spy.newCluck() },
		expect = { true, {} }
	},
	{ -- 10
		name = 'Calling "newCluck" convenience with "foo" as arg',
		func = testConvenience,
		args = { Spy.newCluck(), 'foo' },
		expect = { true, { 'foo' } }
	},
	{ -- 11
		name = 'Calling "newCroak" without args',
		func = testConvenience,
		args = { Spy.newCroak() },
		expect = { false, 'Croak called' }
	},
	{ -- 12
		name = 'Calling "newCroak" convenience with "foo" as arg',
		func = testConvenience,
		args = { Spy.newCroak(), 'foo' },
		expect = { false, 'Croak called: foo' }
	},
	{ -- 13
		name = 'Calling "newConfess" without args',
		func = testConvenience,
		args = { Spy.newConfess() },
		expect = { false, 'Module:SpyTest:21: Confess called' }
	},
	{ -- 14
		name = 'Calling "newConfess" convenience with "foo" as arg',
		func = testConvenience,
		args = { Spy.newConfess(), 'foo' },
		expect = { false, 'Module:SpyTest:21: Confess called: foo' }
	},
}

return testframework.getTestProvider( tests )
