class UserQueryUI extends Widget implements IClickable, IWheelInput, IKeyInput{

  private Event<EventInfoType> m_onClickEvent;
  private Event<MouseMovedEventInfoType> m_onMouseMovedEvent;
  private Event<MouseDraggedEventInfoType> m_onMouseDraggedEvent;
  private Event<KeyPressedEventInfoType> m_onKeyPressedEvent;
  private Event<MouseWheelEventInfoType> m_mouseWheelEvent;

  private Consumer<FlightType[]> m_onLoadDataEvent;

  QueryManagerClass m_queryManager;
  ArrayList <Widget> m_subWidgets = new ArrayList<Widget>();
  private ArrayList<WidgetGroupType> m_groups;
  private ArrayList<String> m_queries;
  private ListboxUI m_queryList;
  private TextboxUI m_day;
  private ButtonUI  clearListButton; 
  private ButtonUI  removeSelectedButton;
  private ButtonUI  addItemButton;
  private int m_listCounter;

  UserQueryUI(int posX, int posY, int scaleX, int scaleY, QueryManagerClass queryManager) {
    super(posX, posY, scaleX, scaleY);

    m_groups = new ArrayList<WidgetGroupType>();
    m_onClickEvent = new Event<EventInfoType>();
    m_onMouseMovedEvent = new Event<MouseMovedEventInfoType>();
    m_onMouseDraggedEvent = new Event<MouseDraggedEventInfoType>();
    m_onKeyPressedEvent = new Event<KeyPressedEventInfoType>();
    m_mouseWheelEvent = new Event<MouseWheelEventInfoType>();

    m_onClickEvent.addHandler(e -> onMouseClick());
    m_onMouseMovedEvent.addHandler(e -> onMouseMoved());
    m_onMouseDraggedEvent.addHandler(e -> onMouseDragged());
    m_onKeyPressedEvent.addHandler(e -> onKeyPressed(e));
    m_mouseWheelEvent.addHandler(e -> onMouseWheel(e));

    m_queryManager = queryManager;

    m_queryList = new ListboxUI<String>(20, 650, 200, 400, 40, v -> v);
    m_queries = new ArrayList<String>();
    m_subWidgets.add(m_queryList); 
    
    addItemButton = new ButtonUI(20, 600, 80, 20);
    m_subWidgets.add(addItemButton);
    addItemButton.setText("Add item");
    addItemButton.getOnClickEvent().addHandler(e -> saveQuery(m_day));
    
    
    clearListButton = new ButtonUI(120, 600, 80, 20);
    m_subWidgets.add(clearListButton);
    clearListButton.setText("Clear");
    clearListButton.getOnClickEvent().addHandler(e -> clearListOnClick());

    removeSelectedButton = new ButtonUI(220, 600, 80, 20);
    m_subWidgets.add(removeSelectedButton);
    removeSelectedButton.setText("Remove selected");
    removeSelectedButton.getOnClickEvent().addHandler(e -> m_queryList.removeSelected());

    m_day =  new TextboxUI(20, 500, 160, 30);
    m_subWidgets.add(m_day);
    m_day.setPlaceholderText("Day");
    

    // Initialise all UI elements
    // Set handlers to functions below
    //   For example, the "save" button should call saveQuery() when clicked
  }

  public void setOnLoadHandler(Consumer<FlightType[]> dataEvent) {
    m_onLoadDataEvent = dataEvent;
  }

  private void loadData() {
    // Load data here. Take info from all user inputs to build queries and apply them

    FlightType[] result = null;
    m_onLoadDataEvent.accept(result);
  }

  private void saveQuery( TextboxUI inputTextbox) {
    // Saves currently written user input into a query
    m_queries.add(inputTextbox.getText());
    m_queryList.add(inputTextbox.getText() + m_listCounter);
    m_listCounter++;
    // Adds to query output field textbox thing
    
    // Set all user inputs back to default
    m_day.setText("");
  }

  private void clearQueries() {
    // Clear all currently saved user queries
  }

  private void changeDataToUS() {
    
  }

  private void changeDataToWorld() {
  }

  @Override
    public void draw() {
    for (var widget : m_subWidgets)
      widget.draw();
  }

  public Event<MouseMovedEventInfoType> getOnMouseMovedEvent() {
    return m_onMouseMovedEvent;
  }

  public Event<MouseDraggedEventInfoType> getOnMouseDraggedEvent() {
    return m_onMouseDraggedEvent;
  }

  public Event<EventInfoType> getOnClickEvent() {
    return m_onClickEvent;
  }

  public Event<KeyPressedEventInfoType> getOnKeyPressedEvent() {
    return m_onKeyPressedEvent;
  }

  public Event<MouseWheelEventInfoType> getOnMouseWheelEvent() {
    return m_mouseWheelEvent;
  }

  private void onMouseMoved() {
    for (Widget widget : m_subWidgets) {
      boolean mouseInsideWidget = widget.isPositionInside(mouseX, mouseY);
      boolean previousMouseInsideWidget = widget.isPositionInside(pmouseX, pmouseY);

      if (mouseInsideWidget && !previousMouseInsideWidget) {
        widget.getOnMouseEnterEvent().raise(new EventInfoType(mouseX, mouseY, widget));
      }

      if (!mouseInsideWidget && previousMouseInsideWidget) {
        widget.getOnMouseExitEvent().raise(new EventInfoType(mouseX, mouseY, widget));
      }
    }
  }

  private void onMouseClick() {
    for (Widget child : m_subWidgets) {
      if (child instanceof IClickable) {
        if (child.isPositionInside(mouseX, mouseY)) {
          ((IClickable)child).getOnClickEvent().raise(new EventInfoType(mouseX, mouseY, child));
          child.setFocused(true);
        } else {
          child.setFocused(false);
        }
      }
    }
  }

  private void onMouseDragged() {
    for (Widget child : m_subWidgets) {
      if (child instanceof IDraggable && child.isPositionInside(pmouseX, pmouseY))
        ((IDraggable)child).getOnDraggedEvent().raise(new MouseDraggedEventInfoType(mouseX, mouseY, pmouseX, pmouseY, child));
    }
  }

  private void onMouseWheel(MouseWheelEventInfoType e) {
    for (Widget child : m_subWidgets) {
      if (child instanceof IWheelInput && (child.isFocused() || child.isPositionInside(mouseX, mouseY)))
        ((IWheelInput)child).getOnMouseWheelEvent().raise(new MouseWheelEventInfoType(mouseX, mouseY, e.wheelCount, child));
    }
  }

 /* private void onKeyPressed(KeyPressedEventInfoType e) {
    for (Widget child : m_subWidgets) {
      if (child instanceof IKeyInput && child.isFocused())
        ((IKeyInput)child).getOnKeyPressedEvent().raise(new KeyPressedEventInfoType(e.X, e.Y, e.pressedKey, e.pressedKeyCode, child));
    }
  }
}*/
 private void onKeyPressed(KeyPressedEventInfoType e) {
    for (Widget child : m_subWidgets) {
      if (child instanceof IKeyInput && child.isFocused())
        ((IKeyInput)child).getOnKeyPressedEvent().raise(new KeyPressedEventInfoType(e.X, e.Y, e.pressedKey, e.pressedKeyCode, child));
    }



    for (WidgetGroupType group : this.m_groups) {
      for (Widget child : group.getMembers()) {
        if (child instanceof IKeyInput && child.isFocused())
          ((IKeyInput)child).getOnKeyPressedEvent().raise(new KeyPressedEventInfoType(e.X, e.Y, e.pressedKey, e.pressedKeyCode, child));
      }
    }
  }
 
  private void clearListOnClick() {
    m_queryList.clear();
  }
}


// F.Wright  created Framework for UserQuery class 8pm 3/14/24
// M.Poole   fixed issue with key input not detecting and implemented Listbox Functionality

/*  TODO!!!!!!!!!!!!!
    1: Make loadData function as intended
    2: Test If you can add and seperate inputs from multiple textboxes at once
    3: Fix issues with space being a delimiter for textBox input
    4: Figure out how the f%&£ to switch data sets without breaking program
    5: Other misc implementation (clearQueries, Seperate inputs etc)


*/ 