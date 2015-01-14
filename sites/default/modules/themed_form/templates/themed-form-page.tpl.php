<?php
/**
 * This file is used to actual render the form into the web browser. In themed_form_theme, we defined a template named
 * 'themed_form_page', which is passed a 'form' argument. This argument is transformed into the $form variable.
 *
 * This $form variable is a form definition, which we created in themed_form_form. We will use drupal_render() to
 * output the individual fields inside whatever HTML markup we need.
 *
 * drupal_render_children() will be used to output any leftover form elements, like form ID's and CSRF tokens.
 */
?>
Our Template File Output

<div class="first_name form_element"><?php echo drupal_render($form['first_name']); ?></div>
<div class="last_name form_element"><?php echo drupal_render($form['last_name']); ?></div>
<div class="submit_button form_element"><?php echo drupal_render($form['submit']); ?></div>

<?php echo drupal_render_children($form); ?>