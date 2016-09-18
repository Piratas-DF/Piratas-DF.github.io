module Jekyll

  class AuthorsGenerator < Generator

    safe true

    def generate(site)
      site.categories.each do |category|
        build_subpages(site, "autor", category)
      end
    end

    def build_subpages(site, type, posts)
      posts[1] = posts[1].sort_by { |p| -p.date.to_f }
      atomize(site, type, posts)
      paginate(site, type, posts)
    end

    def atomize(site, type, posts)
      path = "/autor/#{posts[0]}"
      atom = AtomPageAuthor.new(site, site.source, path, type, posts[0], posts[1])
      site.pages << atom
    end

    def paginate(site, type, posts)
      pages = Jekyll::Paginate::Pager.calculate_pages(posts[1], site.config['paginate'].to_i)
      (1..pages).each do |num_page|
        pager = Jekyll::Paginate::Pager.new(site, num_page, posts[1], pages)
        path = "/autor/#{posts[0]}"
        if num_page > 1
          path = path + "/pagina#{num_page}"
        end
        newpage = GroupSubPageAuthor.new(site, site.source, path, type, posts[0])
        newpage.pager = pager
        site.pages << newpage

      end
    end
  end

  class GroupSubPageAuthor < Page
    def initialize(site, base, dir, type, val)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), "author.html")
      self.data["grouptype"] = type
      self.data[type] = val
    end
  end

  class AtomPageAuthor < Page
    def initialize(site, base, dir, type, val, posts)
      @site = site
      @base = base
      @dir = dir
      @name = 'rss.xml'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), "author.xml")
      self.data[type] = val
      self.data["grouptype"] = type
      self.data["posts"] = posts[0..9]
    end
  end
end