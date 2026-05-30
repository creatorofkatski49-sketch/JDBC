import javafx.collections.*;
import javafx.fxml.FXML;
import javafx.scene.control.*;

import java.sql.*;

public class Controller {

    // --- FXML Fields ---
    @FXML private TextField              txtName;
    @FXML private TextField              txtCourse;
    @FXML private ChoiceBox<YearLevel>   cbYear;

    @FXML private TableView<Student>              table;
    @FXML private TableColumn<Student, Integer>   colId;
    @FXML private TableColumn<Student, String>    colName;
    @FXML private TableColumn<Student, String>    colCourse;
    @FXML private TableColumn<Student, String>    colYear;

    // --- State ---
    private final ObservableList<Student> list = FXCollections.observableArrayList();
    private Connection conn;
    private int selectedId = -1;

    // -----------------------------------------------------------------------
    // Initialization
    // -----------------------------------------------------------------------

    @FXML
    public void initialize() {
        conn = DBConnection.connect();

        if (conn == null) {
            showAlert(Alert.AlertType.ERROR, "Database Error",
                    "Could not connect to the database.\nCheck your .env credentials.");
            return;
        }

        // Populate ChoiceBox with enum values
        cbYear.getItems().setAll(YearLevel.values());

        // Bind table columns to Student properties
        colId.setCellValueFactory(data -> data.getValue().idProperty().asObject());
        colName.setCellValueFactory(data -> data.getValue().nameProperty());
        colCourse.setCellValueFactory(data -> data.getValue().courseProperty());
        colYear.setCellValueFactory(data -> data.getValue().yearLevelProperty());

        loadData();

        // Row click → populate input fields
        table.setOnMouseClicked(e -> {
            Student s = table.getSelectionModel().getSelectedItem();
            if (s != null) {
                selectedId = s.getId();
                txtName.setText(s.getName());
                txtCourse.setText(s.getCourse());

                // Map stored string back to enum
                for (YearLevel y : YearLevel.values()) {
                    if (y.toString().equals(s.getYearLevel())) {
                        cbYear.setValue(y);
                        break;
                    }
                }
            }
        });
    }

    // -----------------------------------------------------------------------
    // Data Loading
    // -----------------------------------------------------------------------

    private void loadData() {
        list.clear();
        try {
            String query = "SELECT * FROM students ORDER BY id";
            ResultSet rs = conn.createStatement().executeQuery(query);
            while (rs.next()) {
                list.add(new Student(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("course"),
                        rs.getString("year_level")
                ));
            }
            table.setItems(list);
        } catch (SQLException e) {
            e.printStackTrace();
            showAlert(Alert.AlertType.ERROR, "Load Error", "Failed to load student records.");
        }
    }

    // -----------------------------------------------------------------------
    // CRUD Operations
    // -----------------------------------------------------------------------

    @FXML
    private void addStudent() {
        if (!validateInputs()) return;

        try {
            String query = "INSERT INTO students(name, course, year_level) VALUES (?, ?, ?)";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setString(1, txtName.getText().trim());
            pst.setString(2, txtCourse.getText().trim());
            pst.setString(3, cbYear.getValue().toString());
            pst.executeUpdate();

            loadData();
            clearFields();
            showAlert(Alert.AlertType.INFORMATION, "Success", "Student added successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
            showAlert(Alert.AlertType.ERROR, "Insert Error", "Failed to add student: " + e.getMessage());
        }
    }

    @FXML
    private void updateStudent() {
        if (selectedId == -1) {
            showAlert(Alert.AlertType.WARNING, "No Selection", "Please select a student to update.");
            return;
        }
        if (!validateInputs()) return;

        try {
            String query = "UPDATE students SET name=?, course=?, year_level=? WHERE id=?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setString(1, txtName.getText().trim());
            pst.setString(2, txtCourse.getText().trim());
            pst.setString(3, cbYear.getValue().toString());
            pst.setInt(4, selectedId);
            pst.executeUpdate();

            loadData();
            clearFields();
            showAlert(Alert.AlertType.INFORMATION, "Success", "Student updated successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
            showAlert(Alert.AlertType.ERROR, "Update Error", "Failed to update student: " + e.getMessage());
        }
    }

    @FXML
    private void deleteStudent() {
        if (selectedId == -1) {
            showAlert(Alert.AlertType.WARNING, "No Selection", "Please select a student to delete.");
            return;
        }

        // Confirmation dialog
        Alert confirm = new Alert(Alert.AlertType.CONFIRMATION);
        confirm.setTitle("Confirm Delete");
        confirm.setHeaderText(null);
        confirm.setContentText("Are you sure you want to delete this student?");
        confirm.showAndWait().ifPresent(response -> {
            if (response == ButtonType.OK) {
                try {
                    String query = "DELETE FROM students WHERE id=?";
                    PreparedStatement pst = conn.prepareStatement(query);
                    pst.setInt(1, selectedId);
                    pst.executeUpdate();

                    loadData();
                    clearFields();
                    showAlert(Alert.AlertType.INFORMATION, "Success", "Student deleted successfully.");

                } catch (SQLException e) {
                    e.printStackTrace();
                    showAlert(Alert.AlertType.ERROR, "Delete Error", "Failed to delete student: " + e.getMessage());
                }
            }
        });
    }

    @FXML
    private void clearFields() {
        txtName.clear();
        txtCourse.clear();
        cbYear.setValue(null);
        selectedId = -1;
        table.getSelectionModel().clearSelection();
    }

    // -----------------------------------------------------------------------
    // Helpers
    // -----------------------------------------------------------------------

    /**
     * Validates that no input field is empty.
     * @return true if all inputs are valid
     */
    private boolean validateInputs() {
        if (txtName.getText().trim().isEmpty()) {
            showAlert(Alert.AlertType.WARNING, "Validation Error", "Name cannot be empty.");
            txtName.requestFocus();
            return false;
        }
        if (txtCourse.getText().trim().isEmpty()) {
            showAlert(Alert.AlertType.WARNING, "Validation Error", "Course cannot be empty.");
            txtCourse.requestFocus();
            return false;
        }
        if (cbYear.getValue() == null) {
            showAlert(Alert.AlertType.WARNING, "Validation Error", "Please select a year level.");
            cbYear.requestFocus();
            return false;
        }
        return true;
    }

    private void showAlert(Alert.AlertType type, String title, String message) {
        Alert alert = new Alert(type);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }
}
