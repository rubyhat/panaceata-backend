SecureHeaders::Configuration.default do |config|
  config.csp = {
    default_src: %w['self'],
    script_src: %w['self' https:],
    style_src: %w['self' https: 'unsafe-inline'],
    img_src: %w['self' data: https:],
    font_src: %w['self' https: data:],
    object_src: %w['none'],
    frame_ancestors: %w['none'],
    base_uri: %w['self']
  }

  config.x_content_type_options = "nosniff"
  config.x_frame_options = "DENY"
  config.x_xss_protection = "1; mode=block"
end
