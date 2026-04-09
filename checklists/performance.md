# Performance Checklist

## Database
- [ ] No N+1 query patterns
- [ ] High-frequency queries have indexes
- [ ] List endpoints have pagination
- [ ] Bulk operations use batching

## API
- [ ] Response time has expected baseline
- [ ] No unnecessary synchronous operations
- [ ] Large files use streaming
- [ ] Appropriate caching strategy in place

## Frontend
- [ ] No unnecessary re-renders
- [ ] Images/assets use lazy loading
- [ ] Bundle size within reasonable range
- [ ] No render-blocking synchronous scripts
