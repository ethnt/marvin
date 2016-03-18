require 'benchmark'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'marvin'

iterations = 1_000

Benchmark.bm(27) do |bm|
  bm.report('lexer') do
    iterations.times do
      runner = Marvin::Lexer.new(File.read('spec/fixtures/test.txt'))
      runner.lex!
    end
  end

  tokens = Marvin::Lexer.new(File.read('spec/fixtures/test.txt')).lex!
  bm.report('parser') do
    iterations.times do
      runner = Marvin::Parser.new(tokens)
      runner.parse!
    end
  end
end
