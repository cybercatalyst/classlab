defprotocol Classlab.Permission do
  def collection(data, action, user)
  def member(data, action, user)
  def can?(data, action, user)
end
