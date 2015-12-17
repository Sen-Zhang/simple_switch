# features
foo = SimpleSwitch::Feature.create(name: 'foo', description: 'Foo Feature')
bar = SimpleSwitch::Feature.create(name: 'bar', description: 'Bar Feature')

# environments
dev  = SimpleSwitch::Environment.create(name: 'development')
test = SimpleSwitch::Environment.create(name: 'test')
prod = SimpleSwitch::Environment.create(name: 'production')

# states mapping
foo.states.create(status: true, environment: dev)
foo.states.create(status: true, environment: test)
foo.states.create(status: false, environment: prod)

bar.states.create(status: true, environment: dev)
bar.states.create(status: false, environment: test)
bar.states.create(status: true, environment: prod)
