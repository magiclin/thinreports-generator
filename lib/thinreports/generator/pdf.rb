# coding: utf-8

begin
  gem 'prawn', '0.12.0'
  require 'prawn'
rescue LoadError
  puts 'ThinReports requires Prawn = 0.12.0. ' +
       'Please `gem install prawn -v 0.12.0` and try again.'
end

module ThinReports
  module Generator
    
    class PDF < Base
      # @param report (see ThinReports::Generator::Base#initialize)
      # @param [Hash] options
      # @option options [Hash] :security (nil)
      #   See Prawn::Document#encrypt_document
      def initialize(report, options)
        super
        
        title = default_layout ? default_layout.format.report_title : nil

        @pdf = Document.new(options, :Title => title)
        @drawers = {}
      end
      
      # @see ThinReports::Generator::Base#generate
      def generate
        draw_report
        @pdf.render
      end
      
      # @see ThinReports::Generator::Base#generate_file
      def generate_file(filename)
        draw_report
        @pdf.render_file(filename)
      end
      
    private
      
      def draw_report
        report.pages.each do |page|
          draw_page(page)
        end
      end
      
      def draw_page(page)
        return @pdf.add_blank_page if page.blank?
        
        format = page.layout.format
        @pdf.start_new_page(format)
        
        drawer(format).draw(page.manager)
      end
      
      def drawer(format)
        @drawers[format.identifier] ||= Drawer::Page.new(@pdf, format)
      end      
    end
    
  end
end

require 'thinreports/generator/pdf/configuration'
require 'thinreports/generator/pdf/prawn_ext'
require 'thinreports/generator/pdf/document'
require 'thinreports/generator/pdf/drawer'
