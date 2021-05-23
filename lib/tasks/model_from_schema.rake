namespace :model_from_schema do
  desc 'Generate model files from db schema'

  task gen: :environment do
    module ModelGenerator
      Models = {}
      module Evaluator
        module_function

        def create_table(table_name, *)
          Models[table_name.classify] = {
              has_many: [],
              belongs_to: [],
          }
        end

        # 無視
        def add_index(*) end
        def add_foreign_key(from, to)
          fromc, toc = from.classify, to.classify
          Models[fromc][:belongs_to].push to.singularize
          Models[toc][:has_many].push from
        end
      end

      def self.save
        Models.each do |klass, data|
          code = [
              "class #{klass} < ActiveRecord::Base",
              data[:has_many].map{|x| "  has_many :#{x}"},
              data[:belongs_to].map{|x| "  belongs_to :#{x}"},
              "end\n",
          ].flatten.join("\n")
          path = Rails.root.join('app', 'models', "#{klass.underscore}.rb")

          File.write(path, code)
        end
      end
    end

    s = ActiveRecord::Schema
    def s.define(*, &block)
      ModelGenerator::Evaluator.class_eval(&block)
    end

    load Rails.root.join('db', 'schema.rb')

    ModelGenerator.save
  end
end