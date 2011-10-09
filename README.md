# Smartgen  [![alt build status][1]][2]

[1]: https://secure.travis-ci.org/smartgen/smartgen.png
[2]: http://travis-ci.org/#!/smartgen/smartgen

Smartgen generates static HTML files from markup files, using textile or markdown and ERB to create layout templates.

## Basic Usage

To use it, you must first add the gem to your Gemfile:

    gem 'smartgen'

Then, create a resource configuration:

    Smartgen[:my_doc].configure do |config|
      config.src_files = ['doc/**/*']
      config.output_folder = 'public/docs'
    end

Finally you generate it:

    Smartgen[:my_doc].generate!

## Adding a layout

By default Smartgen will only parse your textile (*.textile) or markdown (*.md or *.markdown) files, based on their extension and output it. You can setup a layout file that will be used when rendering each file:

    Smartgen[:my_doc].configure do |config|
      config.src_files = ['doc/**/*']
      config.output_folder = 'public/docs'
      config.layout = 'doc/layout.html.erb'
    end

This layout file is an ERB template, that has some methods available, for example this would be a basic layout:

    <html>
    <body>
      <%= markup_file.contents %>
    </body>
    </html>

## Using metadata in layout

You can specify a metadata file and use it in layouts:

    Smartgen[:my_doc].configure do |config|
      config.src_files = ['doc/**/*']
      config.output_folder = 'public/docs'
      config.layout = 'doc/layout.html.erb'
      config.metadata_file = 'doc/metadata.yml'
    end

This would be `doc/metadata.yml` contents

    title: Common title
    pages:
      - &index
        file: index
        title: Index Page
        description: Description for index page
      - &some_page
        file: some_page
        title: Some Page
        description: Description for some page
    menu: [*index, *some_page]

And this could be a layout that makes use of the metadata above:

    <html>
    <head>
      <title><% metadata.current_page.title %> :: <%= metadata.title %></title>
    </head>
    <body>
      <section id="menu">
        <ul>
          <% metadata.menu.each do |entry| %>
            <lu><a href="<%= entry.file %>.html" title="<%= entry.description %>"><%= entry.title %></a></li>
          <% end %>
        </ul>
      </section>

      <section id="contents">
        <%= markup_file.contents %>
      </section>
    </body>
    </html>

As you can see, there is a special metadata method called `current_page`. This is created whenever you declare a pages section in your metadata file with a `file` key that matches the current file being processed. This way you can use this to put specific file metadata when rendering layouts.

## Copying assets

When you generate documentation with Smartgen you'll often need to also copy stylesheets, javascript files and images to the output folder. You can easily do so by specifying an array of dirs to copy when configuring:

    Smartgen[:my_doc].configure do |config|
      config.src_files = ['doc/**/*']
      config.output_folder = 'public/docs'
      config.assets = ['doc/stylesheets', 'doc/javascripts', 'doc/images']
    end

Only directories may be specified. Smartgen will copy the contents of each directory to the output folder, preserving the directory itself. So `doc/stylesheets` will be copied to `public/docs/stylesheets` for example.

## Using different configurations

You may create as many resource configurations as you want. When you call `Smartgen[:some_config_name]`, Smartgen creates a configuration with name `:some_config_name` and then, whenever you use it again, Smartgen returns that configuration. You can even change the configuration by calling `configure`:

    Smartgen[:doc].configure do |config|
      config.src_files = ['doc/**/*']
      config.output_folder = 'public/docs'
      config.layout = 'doc/layout.html.erb'
      config.metadata_file = 'doc/metadata.yml'
    end

    Smartgen[:some_other_documentation].configure do |config|
      config.src_files = ['other_doc/**/*']
      config.output_folder = 'public/other_docs'
      config.layout = 'other_layout.html.erb'
    end

    Smartgen[:doc].generate!
    Smartgen[:some_other_documentation].generate!

## Rake Task

You may also use a rake task:

    require 'smartgen/rake_task'

    Smartgen::RakeTask.new :my_doc do |config|
      config.src_files = ['doc/**/*']
      config.output_folder = 'public/docs'
    end

The yielded config is exactly the same config yielded by Smartgen::Resource#configure method, so you can use any of the above configs.

## Watching for changes

When you are writing documentation it can be boring to always have to regenerate files manually every time you make some changes. Smartgen provides you with a way of regenerate files once they are saved. Just use `Smartgen::WatcherRakeTask`:

    require 'smartgen/watcher_rake_task'
    
    Smartgen::WatcherRakeTask.new :my_doc do |config|
      config.src_files = ['doc/**/*']
      config.output_folder = 'public/docs'
    end

When you run this rake task it will generate files based on this configuration and start watching for changes. Whenever you create, modify or delete a file, it will regenerate all files for you, just reload your browser!

If you want to have the ability to generate files instantly and also have a watcher you can do this:

    require 'smartgen/rake_task'
    require 'smartgen/watcher_rake_task'
    
    Smartgen::RakeTask.new :my_doc do |config|
      config.src_files = ['doc/**/*']
      config.output_folder = 'public/docs'
    end
    
    Smartgen::WatcherRakeTask.new :watch_my_doc, :my_doc

Then you can call both `my_doc` and `watch_my_doc`:

    rake my_doc          # generates files right away
    rake watch_my_doc    # generates files and watch for changes

## Related Gems

* [Smartgen SyntaxHighlighter](http://github.com/smartgen/smartgen_syntaxhighlighter) -- Adds support to use Alex Gorbatchev's Syntax Highlighter plugin with smartgen
* [Smartgen ERB](http://github.com/smartgen/smartgen_erb) -- A ERB preprocessor for smartgen engines

There are some

## Contributors

* [Vicente Mundim](http://github.com/vicentemundim) _(author)_
* [Emerson Leite](http://github.com/emerleite)
* [Rodrigo Lopes](http://github.com/rodvlopes)
* [Marcos Silva Pereira](http://github.com/marcospereira)
* [Wandenberg Peixoto](http://github.com/wandenberg)

## Copyright

Copyright (c) 2011 Vicente Mundim. See LICENSE for details.
