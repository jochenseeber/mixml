QED.configure 'coverage' do
    require 'coveralls'
    require 'simplecov'

    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
        SimpleCov::Formatter::HTMLFormatter,
        Coveralls::SimpleCov::Formatter
    ]

    SimpleCov.refuse_coverage_drop
    SimpleCov.command_name 'QED'

    SimpleCov.start do
        coverage_dir 'log/coverage'
    end
end
