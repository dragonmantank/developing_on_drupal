<?php

/**
 * Implements hook_form().
 * Sample admin form.
 *
 * @param array $form
 *   Current form definition, if any
 * @param array $form_state
 *   Current form state
 *
 * @return array
 *   Form definition
 */
function db_sample_admin_form($form, &$form_state) {
    $form = array();

    // This controls the title in the template used on /db-sample
    $form['db_sample_title'] = array(
        '#type' => 'textfield',
        '#default_value' => variable_get('db_sample_title', 'Database Sample'),
        '#description' => 'Title of the form to display on the webpage',
        '#required' => TRUE,
        '#title' => 'Title',
    );

    return system_settings_form($form);
}