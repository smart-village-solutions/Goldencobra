## Install Goldencobra for development

Clone Goldencobra repository:

```
$ git clone git@github.com:ikuseiGmbH/Goldencobra.git
```

`cd` into `test/dummy` and run:

```
bundle install
```

Remember to run all commands with `bundle exec`.

In `test/dummy/config` create a `database.yml` file, which should be a copy of
`database.yml.template` living in the same directory.

Go to the root directory and run: 

```
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
```

To start the rails server, from `test/dummy` run:

```
bundle exec rails s
```

To run test, from `test/dummy` run:

```
bundle exec rspec spec
```
