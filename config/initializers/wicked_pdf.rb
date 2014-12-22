if Rails.env.production?
    WickedPdf.config[:wkhtmltopdf] = '/usr/local/bin/wkhtmltopdf'
else
    WickedPdf.config[:wkhtmltopdf] = '/usr/bin/wkhtmltopdf'
end
