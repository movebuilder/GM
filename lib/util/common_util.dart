interceptFormat(String? content, {int length = 6}) {
  if (content == null) return '';
  if (content.length > 2 * length) {
    return content.substring(0, length) +
        "..." +
        content.substring(content.length - length, content.length);
  }
  return content;
}
