<img src="graphics/sibyl_logo.png" alt="Sibyl Gem" style="width: 600px;"
width="600" />

In our modern world what holds greater magic than a form?
Within these paper labrinths lies the treasure of some life changing momentous
ocassions. What so many need in this world is someone who will help them
along their journey. Do you have what it takes to answer their call and
become a digital sibyl? Yes, it may be dark magic. But it's POWERFUL!

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'sibyl'
```

And then execute:
```bash
$ bundle install
$ bin/rake sibyl:install
```

## Usage

Start the rails server with
```bash
$ bin/rails server
```

Then in a different terminal Sibyl uses an existing model so create one use an existing one.
```bash
$ bin/rails g scaffold Taskname attrib1:string attrib2:string
$ bin/rails g siblform taskname formname path/to/pdffile.pdf
$ bin/rake sibyl:open
```
## Goals

This project should be easy for anyone to work with. This is why it uses
JQuery UI instead of Bootstrap and very basic Javascript and CSS. Anyone
with any amount of experience should be able to hack on this without
needing to learn Angular. We are targeting Chrome latest for the
admin/editor.

## Contributing

Please help on this project! I'm a "good enough" Ruby on Rails
programmer and could definitely use the help. Work on whatever you think
needs work and create a pull request. It's that simple!

## License

All portions Copyright (C) 2016 Janet Jeffus

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see
    <http://www.gnu.org/licenses/>.
