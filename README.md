Smartgen
========

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

When you generate documentation with Smartgen you'll often need to also copy stylesheets, javascript files and images to the output folder. You can easily do so by specifying an array of assets when configuring:

    Smartgen[:my_doc].configure do |config|
      config.src_files = ['doc/**/*']
      config.output_folder = 'public/docs'
      config.assets = ['doc/stylesheets/*.css', 'doc/javascripts/*.js', 'doc/images/*.{png|jpg|gif}']
    end

As you can see, you can pass an array of `Dir.glob` to either assets or src_files configuration.

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
