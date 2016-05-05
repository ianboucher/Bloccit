module LabelsHelper

  def labels_to_buttons(labels)
    # Here, 'raw' prevents 'map' from escaping the returned string. Escaping
    # removes special characters from a string that could be confused as code. In
    # this case, that could break the links, so would be undesirable.
    raw labels.map { |l| link_to l.name, label_path(id: l.id), class: 'btn-xs btn-primary' }.join(' ')
  end
end
