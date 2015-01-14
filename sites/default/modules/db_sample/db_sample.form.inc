<?php

/**
 * This will call and return our form.
 * This is actually a long-winded way to simply display a form. If you are not doing any processing on the form, you
 * can use drupal_get_form directly in hook_menu() to bypass this. Showing this just for example. See the db_sample_menu
 * entry for 'admin/structure/db-sample' on how to use drupal_get_form directly.
 *
 * This also shows an example of returning a render array instead of a string for a MENU_CALLBACK. Drupal will detect
 * the return type (string or array), and if it's a string will output it. If it's array, Drupal will attempt to use it
 * like a render array. Since a form definition is a renderable array, Drupal will build the form HTML for us.
 *
 * If you need more control over form output, see the themed_form module.
 *
 * @return array
 *   Form definition
 */
function db_sample_form_page() {
    $form = drupal_get_form('db_sample_form');

    return $form;
}

/**
 * Implements hook_form().
 * Simple form definition where we will ask for a first and last name.
 */
function db_sample_form($form, &$form_state) {
    $form = array();
    $form['firstName'] = array(
        '#type' => 'textfield',
        // While Drupal doesn't generate HTML5 elements, we can use #attributes to add HTML5 attributes onto the elements
        '#attributes' => array('placeholder' => 'First Name', 'required' => TRUE),
        '#title' => 'First Name',
    );

    $form['lastName'] = array(
        '#type' => 'textfield',
        '#attributes' => array('placeholder' => 'Last Name', 'required' => TRUE),
        '#title' => 'Last Name',
        // We're going to define a custom element validator for this field. During validation db_sample_lastname_validate()
        // will be called.
        '#element_validate' => array('db_sample_lastname_validate'),
    );

    $form['submit'] = array(
        '#type' => 'submit',
        '#value' => 'Save',
    );

    // If we want to use a different form submission handler, like db_sample_form_submit2, we can uncomment this
    // $form['#submit'] = array('db_sample_form_submit2');

    // If we want to use a different form validation handler, like db_sample_form_validation2, we can uncomment this
    // $form['#validate'] = array('db_sample_form_validate2');

    return $form;
}

/**
 * Custom element validator for the lastname field.
 * This function was set to be called in #element_validate on the lastName element. It will get passed the element and
 * a form state, so we can do whatever validation we need.
 *
 * To set an error, we call form_error() and Drupal will display the error to the user. We do not return a TRUE/FALSE
 * here.
 *
 * @param array $element
 *   Element definition
 * @param $form_state
 *   Current form state
 */
function db_sample_lastname_validate($element, $form_state) {
    if(strtolower($form_state['values']['lastName']) == 'last name') {
        form_error($element, 'Please fill in a valid last name');
    }
}

/**
 * Default form-level validation handler for db_sample_form.
 * This function can be used to validate the entire form at once, instead of relying on custom element validators. This
 * will not stop the custom validators from being called however.
 *
 * If there is an error, we call form_set_error with the element name and the error message. We do not return a
 * TRUE/FALSE here, as Drupal will check for anything set via form_set_error to determine if an error occured. The messages
 * will be displayed to the user.
 *
 * The form values will be in $form_state['values'] for you to work with.
 *
 * @param array $form
 *   Form definition
 * @param array $form_state
 *   Current form state
 */
function db_sample_form_validate($form, $form_state) {
    if(strtolower($form_state['values']['firstName']) == 'first name') {
        form_set_error('firstName', 'Please fill in a valid first name');
    }
}

/**
 * Custom form validation handler for the form.
 * If you uncommented the #validate key in the form definition, this form handler will be called instead of
 * db_sample_form_validate(). This function sets an error on both elements all the time.
 *
 * @param array $form
 *   Form definition
 * @param $form_state
 *   Current form state
 */
function db_sample_form_validate2($form, $form_state) {
    form_set_error('firstName', 'The validator forced this to fail');
    form_set_error('lastName', 'The validator forced this to one to fail as well.');
}

/**
 * Default form submission handler.
 * This form handler will get the form values, and write them to the database that we defined in the .install file.
 * We use drupal_set_message to display a friendly message. You should be able to see the entries on /db-sample
 *
 * @param array $form
 *   Form definition
 * @param $form_state
 *   Current form state
 */
function db_sample_form_submit($form, $form_state) {
    $values = $form_state['values'];

    // Do something with the values... like write them!
    drupal_write_record('db_sample_names', $values);
    drupal_set_message('Info saved');
}

/**
 * Custom form submission handler for the form.
 * If you uncommented the #submit key in the form definition, this form handler will be called instead of
 * db_sample_form_submit(). This function simply dumps the values on the screen and terminates drupal.
 *
 * @param array $form
 *   Form definition
 * @param $form_state
 *   Current form state
 */
function db_sample_form_submit2($form, $form_state) {
    $values = $form_state['values'];
    var_dump($values);
    drupal_exit();
}

