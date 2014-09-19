app = require '../Application'

# Usage: {{scopevar | trusthtml}}
# Required for URLs
trusthtml = ($sce)  ->
  return (t) ->
    return $sce.trustAsHtml(t)


module.exports = trusthtml
app.filter 'trusthtml', ['$sce', trusthtml]