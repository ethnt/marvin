require 'benchmark'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'marvin'

iterations = 100

Benchmark.bm(27) do |bm|
  bm.report('lexer') do
    iterations.times do
      runner = Marvin::Lexer.new(File.read('spec/fixtures/test-declaration.txt'))
      runner.lex!
    end
  end
end
