# Cork

A delightful CLI UI module.

## Usage

```ruby
board = Cork::Board.new()
```

You can use Cork to print simple messages.

```ruby
board.puts('Hello World')
```

You can use notice to print notices to the user colored in green.

```ruby
board.notice("We're out of 🍷.")
```

This is an example of Cork used to build a simple list.

```ruby
board.section('Types of Wine') do
  board.labeled('Red', ['Shiraz', 'Merlot'])
  board.labeled('White', ['Gewürztraminer', 'Riesling'])
end
```

```
Types of Wine
  - Red:
    - Shiraz
    - Merlot
  - White:
    - Gewürztraminer
    - Riesling
```

This is an example of Cork used to print a warning with actions the user can take.

```ruby
board.warn('Merlot is down to 1 oz', [
  'Purchase some more.'
])

board.print_warnings
```

```
[!] Merlot is down to 1 oz
    - Purchase some more.
```
