
class TerraMode
  new: =>
    @lexer = bundle_load('terra_lexer')
    @api = bundle_load('api')
    @completers = { 'in_buffer', 'api' }

  comment_syntax: '--'

  auto_pairs: {
    '(': ')'
    '[': ']'
    '{': '}'
    '"': '"'
    "'": "'"
  }

  indentation: {
    more_after: {
      r'[({=]\\s*(--.*|)$' -- hanging operators
      r'function\\b\\s*[^(]*\\([^)]*\\)\\s*(--.*|)$' -- function starter
      r'terra\\b\\s*[^(]*\\([^)]*\\)\\s*(--.*|)$' -- function starter
      r'\\b(then|do)\\b\\s*(--.*|)$', -- block starters
      { '^%s*if%s+', '%s+end$' }
      r'^\\s*else\\b',
    }

    less_for: {
      r'^\\s*end\\b'
      '^%s*}'
      r'^\\s*else\\b'
      r'^\\s*elseif\\b'
      r'^\\s*\\}\\b'
    }
  }

  code_blocks:
    multiline: {
      { r'\\s+then\\s*$', '^%s*end', 'end' },
      { r'(^\\s*|\\s+)function\\s*\\([^)]*\\)\\s*$', '^%s*end', 'end' },
      { r'^\\s*function\\s+\\w+[_:.\\w]+\\s*\\([^)]*\\)\\s*$', '^%s*end', 'end' },
      { r'^\\s*terra\\s+\\w+[_:.\\w]+\\s*\\([^)]*\\)\\s*$', '^%s*end', 'end' },
      { r'(^\\s*|\\s+)do\\s*$', '^%s*end', 'end' },
      { r'^\\s*repeat\\s*$', '^%s*until', 'until' },
    }
