QED.configure 'coverage' do
    require 'coveralls'
    require 'simplecov'

    Coveralls.wear!

    SimpleCov.start do
        coverage_dir 'log/coverage'
    end
end
