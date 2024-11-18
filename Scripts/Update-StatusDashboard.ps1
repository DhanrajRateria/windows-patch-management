Add-Type -AssemblyName System.Windows.Forms

# Form Configuration
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Patch Management Dashboard"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"

# Label for Status
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Update Status: Initializing..."
$statusLabel.Location = New-Object System.Drawing.Point(50, 50)
$statusLabel.Size = New-Object System.Drawing.Size(300, 50)
$form.Controls.Add($statusLabel)

# Button to Refresh Status
$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Text = "Refresh Status"
$refreshButton.Location = New-Object System.Drawing.Point(50, 120)
$refreshButton.Size = New-Object System.Drawing.Size(150, 30)
$refreshButton.Add_Click({
    $updates = Get-SystemUpdates
    if ($updates) {
        $statusLabel.Text = "Update Status: Pending Updates Found"
    } else {
        $statusLabel.Text = "Update Status: System Up-to-Date"
    }
})
$form.Controls.Add($refreshButton)

# Show Form
$form.ShowDialog()
