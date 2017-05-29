class Goldencobra::Article::UploadInput
  include Formtastic::Inputs::Base

  def to_html
    input_wrapping do
      label_html << builder.template.content_tag(
        :a,
        "Dialog öffnen",
        href: "#",
        class: "button article_upload_open",
        data: {
          articleId: object.article_id || options.fetch(:article_id, nil),
          imageId: object.image_id
        }
      ) + builder.template.content_tag(
        :div,
        "<h2>test<h2>".html_safe,
        style: "display: none;"
      )
    end
  end
end
