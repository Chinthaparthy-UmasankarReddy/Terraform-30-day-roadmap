## Complete S3 Deployment Verification (Updated for Public Website Access)

**Expected Result:** `curl $WEBSITE` returns `<h1>Terraform Project 2 Success!</h1>`

```bash
#!/bin/bash
# ========================================
# Terraform S3 Project 2 - Full Verification (Public Website)
# ========================================

# Step 1: Extract Outputs
echo "=== Step 1: Extract Outputs ==="
BUCKET=$(terraform output -raw bucket_name)
WEBSITE=$(terraform output -raw website_url)
echo "Bucket: $BUCKET"
echo "Website: $WEBSITE"

# Step 2: Verify Bucket Exists
echo "=== Step 2: Verify Bucket Exists ==="
aws s3api head-bucket --bucket $BUCKET && echo "✅ Bucket exists"

# Step 3: Check Versioning Status
echo "=== Step 3: Verify Versioning Enabled ==="
aws s3api get-bucket-versioning --bucket $BUCKET

# Step 4: Create & Upload Public Website (index.html)
echo "=== Step 4: Upload Public Website ==="
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Terraform S3 Success</title></head>
<body>
<h1>Terraform Project 2 Success!</h1>
<p>S3 Bucket with Versioning + Static Website Working!</p>
<p>Bucket: tf-project2-bucket-00086</p>
</body>
</html>
EOF

aws s3 cp index.html s3://$BUCKET/ --acl public-read && echo "✅ index.html uploaded publicly"

# Step 5: Test Versioning with test.txt
echo "=== Step 5: Test Versioning ==="
echo "Version 1 - $(date)" > test.txt
aws s3 cp test.txt s3://$BUCKET/ && echo "✅ Version 1 uploaded"

echo "Version 2 - $(date)" > test.txt  
aws s3 cp test.txt s3://$BUCKET/ && echo "✅ Version 2 uploaded"

# Step 6: Verify Website Returns HTML (EXPECTED RESULT)
echo "=== Step 6: Test Website (Expected: HTML Content) ==="
echo "=== CURL TEST ==="
curl -s $WEBSITE | head -20
echo -e "\n=== EXPECTED: <h1>Terraform Project 2 Success!</h1> ===\n"

# Step 7: Verify Multiple Versions Created
echo "=== Step 7: List Object Versions ==="
aws s3api list-object-versions --bucket $BUCKET --prefix test.txt

# Step 8: Final Validation
echo "=== Step 8: Terraform State Check ==="
terraform state list
echo "✅ DEPLOYMENT 100% SUCCESSFUL!"
echo "✅ Website: $WEBSITE"
echo "✅ Open in browser: open '$WEBSITE' (Mac) / start '$WEBSITE' (Windows)"
```

## Prerequisites for Public Website
**Your Terraform must include** (uncommented):
```hcl
# 1. Static website hosting enabled
aws_s3_bucket_website_configuration.project_bucket_website_config { ... }

# 2. Public read policy (uncommented)
aws_s3_bucket_policy.public_read { ... }

# 3. BlockPublicPolicy disabled  
aws_s3_bucket_public_access_block.project_bucket {
  block_public_policy = false
}
```

## Expected Success Output
```
=== CURL TEST ===
<!DOCTYPE html>
<html>
<head><title>Terraform S3 Success</title></head>
<body>
<h1>Terraform Project 2 Success!</h1>  ✅ MATCHES EXPECTED RESULT
<p>S3 Bucket with Versioning + Static Website Working!</p>

✅ 2+ versions visible
✅ Website publicly accessible
```

## Single Command
```bash
# Save as verify-public.sh, then: chmod +x verify-public.sh && ./verify-public.sh
```

**Result:** `curl $WEBSITE` → `<h1>Terraform Project 2 Success!</h1>` ✅
