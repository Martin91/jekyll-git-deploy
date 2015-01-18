# ansi_colors.rb
# Implement add ansi color escape code to normal string
#
# Created by Martin Hong on 1/17/2015
# Copyright (c) 2015 Martin Hong. All rights reserved.
#

String.class_eval do
  # ==== Start colors with ANSI escape code ====
  #
  # ANSI colors excape code format:
  # => Color=\033[code;前景;背景m
  #
  # More details can be retrieved from: http://en.wikipedia.org/wiki/ANSI_escape_code
  #
  # ANSI
  #   Foreground        Background       Color
  #   ---------------------------------------
  #   30                40               Black
  #   31                41               Red
  #   32                42               Green
  #   33                43               Yellow
  #   34                44               Blue
  #   35                45               Purple
  #   36                46               Blue-Green
  #   37                47               White
  #   1                 1                Transparent
  #
  #   Code              Function
  #   -------------------------
  #   0                 OFF
  #   1                 Highline
  #   4                 Underline
  #   5                 Flash
  #   7                 Reverse Display
  #   8                 Invisiable
  #
  RED = "\033[0;31;1m"            # Dangerous Color
  YELLOW = "\033[0;33;1m"         # Warning Color
  GREEN = "\033[0;32;1m"          # Infos Color
  DEFAULT = "\033[0;39;49m"        # RESET COLOR
  # ====  End colors with ANSI escape code  ====

  # Usages:
  #
  #   "Hello world".red
  #   "Hello world".green
  #   "Hello world".yellow
  #
  %w(red yellow green).each do |method|
    unless method_defined?(method)
      define_method method do
        prepend self.class.const_get(method.upcase)
        concat DEFAULT
      end
    end
  end
end
