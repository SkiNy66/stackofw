ThinkingSphinx::Index.define :user, with: :active_record do
  #fields
  indexes user.email, as: :author, sortable: true

  #attributes
  has created_at, updated_at
end