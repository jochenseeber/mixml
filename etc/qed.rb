QED.configure 'coverage' do
    require 'simplecov'
    SimpleCov.start do
        coverage_dir 'log/coverage'
    end
end
