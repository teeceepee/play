# Rouge dockerfile lexer
module Rouge
  module Lexers
    class Dockerfile < RegexLexer
      tag 'dockerfile'

      title "Dockerfile"
      desc 'A generic lexer for Dockerfiles'
      filenames 'Dockerfile'

      KEYWORDS = %w(
        from
        maintainer
        run
        cmd
        label
        expose
        env
        add
        copy
        entrypoint
        volume
        user
        workdir
        arg
        onbuild
        stopsignal
      ).join('|')

      state :root do
        rule /^#{KEYWORDS}/i, Keyword
        rule /.*\n?/ do |m|
          delegate Shell
        end
      end
    end
  end
end
